'use strict'

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
      body: JSON.stringify({ status: 200 })
    }
    callback(null, response)
  }
}
