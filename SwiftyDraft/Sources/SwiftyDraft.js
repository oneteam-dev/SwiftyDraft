import React, { Component } from 'react';
import RichTextEditor from 'oneteam-rte';
import WebCardAtomicBlock from './components/TopicEditor/components/Editor/components/RichTextEditor/components/WebCardAtomicBlock';
import PlaceholderAtomicBlock from './components/TopicEditor/components/Editor/components/RichTextEditor/components/PlaceholderAtomicBlock';
import FilePlaceholderAtomicBlock from './components/TopicEditor/components/Editor/components/RichTextEditor/components/FilePlaceholderAtomicBlock';
import { WEB_CARD, PLACEHOLDER, FILE_PLACEHOLDER } from 'oneteam-rte/lib/constants';

export default class SwiftyDraft extends Component {
    constructor(props) {
        super(props);
        this.editor = null;
        this.state = { editorState: {}, paddingTop: 0, rawMentions:[], hashtagList:[] };
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
        return this.state.placeholder;
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
            this.editor.focus();
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
    set rawMentions(rawMentions) {
        this.setState({ rawMentions });
    }
    get rawMentions() {
        return this.state.rawMentions;
    }
    set hashtagList(hashtagList) {
        this.setState({ hashtagList });
    }
    get hashtagList() {
        return this.state.hashtagList;
    }

    render() {
        return (
            <div style={{ paddingTop: this.state.paddingTop }}>
              <RichTextEditor
	                rawMentions={this.state.rawMentions}
	                hashtagList={this.state.hashtagList}
                  onChange={() => { this.triggerOnChange() }}
                  placeholder={this.state.placeholder}
                  atomicBlockRenderMap={{
                      [WEB_CARD]: WebCardAtomicBlock,
                      [PLACEHOLDER]: PlaceholderAtomicBlock,
                      [FILE_PLACEHOLDER]: FilePlaceholderAtomicBlock
                    }}
                  ref={(c) => this.setEditor(c)}>
              </RichTextEditor>
            </div>
        )
    }
}
