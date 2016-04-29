import React, { Component } from 'react';
import RichTextEditor from 'oneteam-rte';

export default class SwiftyDraft extends Component {
    constructor(props) {
        super(props);
    }
    render() {
        return (
            <RichTextEditor
                onClickAddImage={() => {}}
                onClickFileAttach={() => {}}
                tooltipTexts={{}} />
        )
    }
}
