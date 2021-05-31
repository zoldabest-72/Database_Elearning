const { check, validationResult } = require('express-validator');

module.exports = {
    AAOaddClassForm: [
        check('name')
        .isLength({ min: 1, max: 10 })
        .withMessage('Tên lớp không được để trống và phải ngắn hơn 10 ký tự')
    ]
}