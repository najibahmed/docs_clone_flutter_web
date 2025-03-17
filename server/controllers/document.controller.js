const DocumentService = require("../services/documentService")
const docService = new DocumentService();

module.exports = class AuthController {

    async CreateDoc(req, res) {
        try {
            const { createdAt } = req.body;
            const result = await docService.createDocument(req.user, createdAt)
            if (result) {
                res.status(200).json({
                    message: "Document created.",
                    document: result,
                });
            }
        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
            });
        }
    }
    async getDoc(req, res) {
        try {
            const result = await docService.getDocuments(req.user)
            if (result) {
                res.status(200).json({
                    message: "Document fetched",
                    documents: result,
                });
            }
        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
            });
        }
    }




}