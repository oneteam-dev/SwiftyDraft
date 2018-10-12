import React, { Component } from 'react';
import PropTypes from 'prop-types';
import mapFileIcon from '../../../../../../../../helpers/mapFileIcon';
import './index.styl';

const DownloadCard = ({ name, text, contentType }) => {
  // const fileIcon = mapFileIcon(contentType, name);
  return (
    <div className='download-card'>
      <div className='file-icon'>
        <img src={require(`../../../../../../../../images/file-icons/${fileIcon}.png`)} />
      </div>
      <div className='info'>
        <div className='file-name'>{name}</div>
        {text ? <div className='text'>{text}</div> : null}
      </div>
    </div>
  );
};

// eslint-disable-next-line react/no-multi-comp
export default class PlaceholderAtomicBlock extends Component {
  render() {
    const { offsetKey, blockProps: { name, text, contentType } } = this.props;
    return (
      <div
        data-offset-key={offsetKey}
        className='placeholder-atomic-block'>
        <DownloadCard name={name} text={text} contentType={contentType} />
      </div>
    );
  }
  static propTypes = {
    blockProps: PropTypes.shape({
      name: PropTypes.string.isRequired,
      text: PropTypes.string.isRequired
    }).isRequired,
    offsetKey: PropTypes.string.isRequired
  }
}
