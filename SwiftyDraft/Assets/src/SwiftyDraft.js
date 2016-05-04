import React, { Component } from 'react';
import RichTextEditor from 'oneteam-rte';

export default class SwiftyDraft extends Component {
    constructor(props) {
        super(props);
        this.editor = null;
        this.state = { editorState: {} };
    }
    setEditor(editor) {
        this.editor = editor;
    }
    focus() {
        if(this.editor) {
            this.editor.focus();
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
    render() {
        return (
            <RichTextEditor
                ref={(c) => this.setEditor(c)}
                onClickAddImage={() => {}}
                onClickFileAttach={() => {}}
                tooltipTexts={{}} />
        )
    }
}
