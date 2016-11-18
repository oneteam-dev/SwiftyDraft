webpackHotUpdate(0,{

/***/ 484:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var _react = __webpack_require__(8);

	var _react2 = _interopRequireDefault(_react);

	var _reactDom = __webpack_require__(485);

	var _reactDom2 = _interopRequireDefault(_reactDom);

	var _SwiftyDraft = __webpack_require__(!(function webpackMissingModule() { var e = new Error("Cannot find module \"./SwiftyDraft\""); e.code = 'MODULE_NOT_FOUND'; throw e; }()));

	var _SwiftyDraft2 = _interopRequireDefault(_SwiftyDraft);

	__webpack_require__(1042);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	_reactDom2.default.render(_react2.default.createElement(_SwiftyDraft2.default, { ref: function ref(c) {
	        return window.editor = c;
	    } }), document.getElementById('app-root'));

/***/ }

})