const express = require("express");
const Document = require("../models/document.model");
const router = express.Router();
const DocumentController = require("../controllers/document.controller");
const documentController =new DocumentController();
const auth = require("../middlewares/auth");


router.post("/create",auth, documentController.CreateDoc)
router.post("/title",auth, documentController.UpdateDocTitle)
router.get("/",auth, documentController.GetAllDoc)
router.get("/:id",auth, documentController.GetSingleDoc)
module.exports = router;