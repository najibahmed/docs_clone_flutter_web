const express = require("express");
const Document = require("../models/document.model");
const router = express.Router();
const DocumentController = require("../controllers/document.controller");
const documentController =new DocumentController();
const auth = require("../middlewares/auth");

router.post("/create",auth, documentController.CreateDoc)

module.exports = router;