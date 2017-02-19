'use strict'

const aws = require('aws-sdk')
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
      statusCode: 200,
      body: JSON.stringify(event)
    }
    callback(null, response)
  }
}
