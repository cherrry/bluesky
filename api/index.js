'use strict'

module.exports = {
  ping(event, context, callback) {
    const response = {
      statusCode: 200,
      body: JSON.stringify({ status: 200 })
    }
    callback(null, response)
  }
}
