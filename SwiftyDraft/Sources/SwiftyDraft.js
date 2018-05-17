import React, { Component } from 'react';
import RichTextEditor from 'oneteam-rte';

export default class SwiftyDraft extends Component {
    constructor(props) {
        super(props);
        this.editor = null;
        this.state = { editorState: {}, paddingTop: 0 };
    }
    set paddingTop(paddingTop) {
        this.setState({ paddingTop });
    }
    get paddingTop() {
        return this.state.paddingTop;
    }
    set placeholder(value) {
        this.setState({ placeholder: value });
    }
    get placeholder() {
        return this.state.placeholder
    }
    setEditor(editor) {
        this.editor = editor;
    }
    focus() {
        if(this.editor) {
            this.editor.focus();
        }
    }
    blur() {
        if(this.editor) {
            this.editor.blur();
        }
    }
    insertImage(...args) {
        if(this.editor) {
            this.editor.insertImageAtomicBlock(...args);
        }
    }
    insertDownloadLink(...args) {
        if(this.editor) {
            this.editor.html += "<a href=\"" + arguments[0]["url"] + "\" target=\"_blank\">"+ arguments[0]["title"] +"</a>"
        }
    }
    insertIFrame(tag) {
        if(this.editor) {
            this.editor.insertIFrameAtomicBlock(tag);
        }
    }
    toggleLink(url = null) {
        if(this.editor) {
          this.editor.toggleLink(url);
        }
    }
    toggleBlockType(type) {
        if(this.editor) {
            this.editor.toggleBlockType(type);
        }
    }
    toggleInlineStyle(style) {
        if(this.editor) {
            this.editor.toggleInlineStyle(style);
        }
    }
    getCurrentInlineStyles() {
        if(this.editor) {
            return this.editor.getCurrentInlineStyles();
        }
        return [];
    }
    getCurrentBlockType() {
        if(this.editor) {
            return this.editor.getCurrentBlockType();
        }
        return "";
    }
    setCallbackToken(callbackToken) {
        this.setState({callbackToken});
        window.webkit.messageHandlers.didSetCallbackToken.postMessage(callbackToken);
    }
    debugLog(data) {
        if(console.debug) {
          console.debug(data);
        }
        window.webkit.messageHandlers.debugLog.postMessage(data);
    }
    getHTML() {
        if(this.editor) {
          return this.editor.html;
        }
        return "";
    }
    setHTML(html) {
        if(this.editor) {
          this.editor.html = html;
        }
    }
    triggerOnChange() {
        const data = {
            inlineStyles: this.getCurrentInlineStyles(),
            blockType: this.getCurrentBlockType(),
            html: this.editor.html,
            state: this.editor.state.editorState.getSelection().getHasFocus()
        };
        window.webkit.messageHandlers.didChangeEditorState.postMessage(data);
    }
    render() {
        return (
            <div style={{ paddingTop: this.state.paddingTop }}>
              <RichTextEditor
                  rawMentions={[]} // NOTE: this property is required. please update this later @keito5656.
                  // refs:
                  // https://github.com/oneteam-dev/oneteam-rte/blob/abcbf4338f9ab9467f96bce95a282a5ad7c3111c/src/RichTextEditor.js#L43-L45
                  // https://github.com/oneteam-dev/react-oneteam/blob/f54df7e2d0dbab1a6fe49f62987e23a19bf01d61/src/Mention/index.js#L18-L30
                  onChange={() => { this.triggerOnChange() }}
                  ref={(c) => this.setEditor(c)}>
              </RichTextEditor>
            </div>
        )
    }
}
