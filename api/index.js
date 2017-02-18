'use strict'

module.exports = {
  ping(event, context, callback) {
    const response = {
      statusCode: 200,
      body: "pong"
    }
    callback(null, response)
  }
}
