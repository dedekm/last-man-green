express = require('express')
router = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index', title: 'Last Man Green'
  return
  
module.exports = router
