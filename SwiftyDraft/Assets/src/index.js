import React from 'react';
import ReactDOM from 'react-dom';
import SwiftyDraft from './SwiftyDraft';
import './index.styl';

ReactDOM.render((
    <SwiftyDraft ref={c => window.editor = c} />
), document.getElementById('app-root'));
