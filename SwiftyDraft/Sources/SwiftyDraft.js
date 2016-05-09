import React, { Component } from 'react';
import RichTextEditor, { Body } from 'oneteam-rte';

export default class SwiftyDraft extends Component {
    constructor(props) {
        super(props);
        this.editor = null;
        this.state = { editorState: {}, paddingTop: 0 };
    }
    setPaddingTop(paddingTop) {
        this.setState({ paddingTop });
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
        this.callbackNavigation('didSetCallbackToken', callbackToken);
    }
    debugLog(data) {
        if(console.debug) {
          console.debug(data);
        }
        this.callbackNavigation('debugLog', data);
    }
    getHTML() {
        if(this.editor) {
          return this.editor.serializedHTML;
        }
        return "";
    }
    triggerOnChange() {
        const data = {
            inlineStyles: this.getCurrentInlineStyles(),
            blockType: this.getCurrentBlockType()
        };
        this.callbackNavigation('didChangeEditorState', data);
    }
    callbackNavigation(method, data) {
        const {callbackToken} = this.state;
        if(callbackToken) {
            const path = [method, encodeURIComponent(JSON.stringify(data))].join('/');
            window.location.href = `callback-${callbackToken}://swifty-draft.internal/${path}`;
        }
    }
    render() {
        return (
            <div style={{ paddingTop: this.state.paddingTop }}>
              <RichTextEditor
                  onChange={() => { this.triggerOnChange() }}
                  ref={(c) => this.setEditor(c)}>
                  <Body />
              </RichTextEditor>
            </div>
        )
    }
}
