webpackHotUpdate(0,{

/***/ 623:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	var _react = __webpack_require__(8);

	var _react2 = _interopRequireDefault(_react);

	var _oneteamRteConstants = __webpack_require__(629);

	var _oneteamRte = __webpack_require__(630);

	var _oneteamRte2 = _interopRequireDefault(_oneteamRte);

	var _HOCWebCard = __webpack_require__(1032);

	var _HOCWebCard2 = _interopRequireDefault(_HOCWebCard);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	//import WebCard from './WebCard';

	var SwiftyDraft = function (_Component) {
	    _inherits(SwiftyDraft, _Component);

	    function SwiftyDraft(props) {
	        _classCallCheck(this, SwiftyDraft);

	        var _this = _possibleConstructorReturn(this, (SwiftyDraft.__proto__ || Object.getPrototypeOf(SwiftyDraft)).call(this, props));

	        _this.editor = null;
	        _this.state = { editorState: {}, paddingTop: 0 };
	        return _this;
	    }

	    _createClass(SwiftyDraft, [{
	        key: 'setEditor',
	        value: function setEditor(editor) {
	            this.editor = editor;
	        }
	    }, {
	        key: 'focus',
	        value: function focus() {
	            if (this.editor) {
	                this.editor.focus();
	            }
	        }
	    }, {
	        key: 'blur',
	        value: function blur() {
	            if (this.editor) {
	                this.editor.blur();
	            }
	        }
	    }, {
	        key: 'insertImage',
	        value: function insertImage() {
	            if (this.editor) {
	                var _editor;

	                (_editor = this.editor)._insertImage.apply(_editor, arguments);
	            }
	        }
	    }, {
	        key: 'insertDownloadLink',
	        value: function insertDownloadLink() {
	            if (this.editor) {
	                var _editor2;

	                (_editor2 = this.editor)._insertDownloadLink.apply(_editor2, arguments);
	            }
	        }
	    }, {
	        key: 'insertIFrame',
	        value: function insertIFrame(iframeTag) {
	            if (this.editor) {
	                this.editor._insertIFrame(iframeTag); // FIXME: DO NOT call private method
	            }
	        }
	    }, {
	        key: 'toggleLink',
	        value: function toggleLink() {
	            var url = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : null;

	            if (this.editor) {
	                this.editor.toggleLink(url);
	            }
	        }
	    }, {
	        key: 'toggleBlockType',
	        value: function toggleBlockType(type) {
	            if (this.editor) {
	                this.editor.toggleBlockType(type);
	            }
	        }
	    }, {
	        key: 'toggleInlineStyle',
	        value: function toggleInlineStyle(style) {
	            if (this.editor) {
	                this.editor.toggleInlineStyle(style);
	            }
	        }
	    }, {
	        key: 'getCurrentInlineStyles',
	        value: function getCurrentInlineStyles() {
	            if (this.editor) {
	                return this.editor.getCurrentInlineStyles();
	            }
	            return [];
	        }
	    }, {
	        key: 'getCurrentBlockType',
	        value: function getCurrentBlockType() {
	            if (this.editor) {
	                return this.editor.getCurrentBlockType();
	            }
	            return "";
	        }
	    }, {
	        key: 'setCallbackToken',
	        value: function setCallbackToken(callbackToken) {
	            this.setState({ callbackToken: callbackToken });
	            window.webkit.messageHandlers.didSetCallbackToken.postMessage(callbackToken);
	        }
	    }, {
	        key: 'debugLog',
	        value: function debugLog(data) {
	            if (console.debug) {
	                console.debug(data);
	            }
	            window.webkit.messageHandlers.debugLog.postMessage(data);
	        }
	    }, {
	        key: 'getHTML',
	        value: function getHTML() {
	            if (this.editor) {
	                return this.editor.html;
	            }
	            return "";
	        }
	    }, {
	        key: 'setHTML',
	        value: function setHTML(html) {
	            print("---------------");
	            if (this.editor) {
	                this.editor.html = html;
	            }
	        }
	    }, {
	        key: 'triggerOnChange',
	        value: function triggerOnChange() {
	            var data = {
	                inlineStyles: this.getCurrentInlineStyles(),
	                blockType: this.getCurrentBlockType(),
	                html: this.editor.html
	            };
	            window.webkit.messageHandlers.didChangeEditorState.postMessage(data);
	        }
	    }, {
	        key: 'customAtomicBlockRendererFn',
	        value: function customAtomicBlockRendererFn(entity, block) {
	            var _this2 = this;

	            var key = entity.getType();
	            console.log("---------------");
	            console.log(key);
	            if (key === _oneteamRteConstants.ENTITY_TYPES.WEB_CARD) {
	                var data = entity.getData();
	                console.log(key);
	                return {
	                    component: _HOCWebCard2.default,
	                    props: {
	                        url: data.url,
	                        imageRemoved: data.imageRemoved,
	                        onDelete: function onDelete() {
	                            return _this2.editor.removeBlock(block);
	                        },
	                        onRemoveImage: function onRemoveImage() {
	                            return _this2.editor.mergeEntityData(block.getEntityAt(0), { imageRemoved: true });
	                        }
	                    },
	                    editable: false
	                };
	            }
	            return null;
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var _this3 = this;

	            return _react2.default.createElement(
	                'div',
	                { style: { paddingTop: this.state.paddingTop } },
	                _react2.default.createElement(
	                    _oneteamRte2.default,
	                    {
	                        onChange: function onChange() {
	                            _this3.triggerOnChange();
	                        },
	                        ref: function ref(c) {
	                            return _this3.setEditor(c);
	                        } },
	                    _react2.default.createElement(_oneteamRte.Body, {
	                        placeholder: this.placeholder,
	                        ref: function ref(c) {
	                            return _this3.body = c;
	                        },
	                        customAtomicBlockRendererFn: this.customAtomicBlockRendererFn
	                    })
	                )
	            );
	        }
	    }, {
	        key: 'paddingTop',
	        set: function set(paddingTop) {
	            this.setState({ paddingTop: paddingTop });
	        },
	        get: function get() {
	            return this.state.paddingTop;
	        }
	    }, {
	        key: 'placeholder',
	        set: function set(value) {
	            this.setState({ placeholder: value });
	        },
	        get: function get() {
	            return this.state.placeholder || _oneteamRte.Body.defaultProps.placeholder;
	        }
	    }]);

	    return SwiftyDraft;
	}(_react.Component);

	exports.default = SwiftyDraft;

/***/ }

})