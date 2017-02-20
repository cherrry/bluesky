'use strict'

const AWS = require('aws-sdk')
const dynamo = new AWS.DynamoDB.DocumentClient()

const TableName = 'bluesky_pmdata'

module.exports = {
  get(event, context, callback) {
    const params = event.queryStringParameters

    const hasDeviceId = params.hasOwnProperty('device_id')
    const hasTimeRange = params.hasOwnProperty('from') && params.hasOwnProperty('to')

    if (!(hasDeviceId && hasTimeRange)) {
      const response = {
        statusCode: 400,
        body: JSON.stringify({
          status: 400,
          message: 'Bad Request'
        })
      }
      callback(null, response)
      return
    }

    dynamo.query({
      TableName,
      KeyConditionExpression: 'device_id = :device_id AND #timestamp BETWEEN :from AND :to',
      ExpressionAttributeNames: {
        '#timestamp': 'timestamp'
      },
      ExpressionAttributeValues: {
        ':device_id': params.device_id,
        ':from': parseInt(params.from),
        ':to': parseInt(params.to)
      }
    }, function (err, data) {
      console.log(data.Items)
      const response = {
        statusCode: 200,
        body: JSON.stringify(data.Items.map(function (item) {
          return {
            timestamp: item.timestamp,
            readings: item.readings
          }
        }))
      }
      callback(null, response)
    })
  },

  put(event, context, callback) {
    const response = {
      statusCode: 202,
      body: JSON.stringify({ status: 202 })
    }
    dynamo.put({
      TableName,
      Item: JSON.parse(event.body)
    }, callback)
  }
}
