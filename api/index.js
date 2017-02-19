'use strict'

const AWS = require('aws-sdk')
const dynamo = new AWS.DynamoDB.DocumentClient()

const TableName = 'bluesky_pmdata'

module.exports = {
  get(event, context, callback) {
    const response = {
      statusCode: 200,
      body: JSON.stringify({ status: 200 })
    }
    callback(null, response)
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
