import React, { Component } from 'react';
import PropTypes from 'prop-types';
// import EditableWebCard from 'components/utils/WebCard/Editable';
import './index.styl';

export default class WebCardAtomicBlock extends Component {
  shouldComponentUpdate(nextProps) { // eslint-disable-line complexity
    const { offsetKey, blockProps: { url, imageRemoved, onDelete, onRemoveImage } } = this.props;
    return nextProps.offsetKey !== offsetKey
      || nextProps.blockProps.url !== url
      || nextProps.blockProps.imageRemoved !== imageRemoved
      || nextProps.blockProps.onDelete !== onDelete
      || nextProps.blockProps.onRemoveImage !== onRemoveImage;
  }
  render() {
    const { blockProps: { url, imageRemoved, onDelete, onRemoveImage } } = this.props;
    return (
      <div data-offset-key={this.props.offsetKey} className='webcard-atomic-block'>

      </div>
    );
  }
  static propTypes = {
    blockProps: PropTypes.shape({
      url: PropTypes.string.isRequired,
      imageRemoved: PropTypes.bool,
      onDelete: PropTypes.func.isRequired,
      onRemoveImage: PropTypes.func.isRequired
    }).isRequired,
    offsetKey: PropTypes.string.isRequired
  }
}
