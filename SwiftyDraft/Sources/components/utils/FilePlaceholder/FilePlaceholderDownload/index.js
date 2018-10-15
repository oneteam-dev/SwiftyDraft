import React from 'react';
import PropTypes from 'prop-types';
import { OverlayTrigger, Tooltip } from 'react-bootstrap';
import SvgIcon from '../../SvgIcon';
import './index.styl';

const FilePlaceholderDownload = ({ id, url }) => {
  return (
    <OverlayTrigger placement='top' overlay={
      <Tooltip id={`${url}-${id}`}>Download</Tooltip>
    }>
      <span className='file-placeholder-download-button'>
        <SvgIcon name='download' />
        <SvgIcon name='download-blue' />
      </span>
    </OverlayTrigger>
  );
};

FilePlaceholderDownload.propTypes = {
  id: PropTypes.string.isRequired,
  url: PropTypes.string,
};

export default FilePlaceholderDownload;
