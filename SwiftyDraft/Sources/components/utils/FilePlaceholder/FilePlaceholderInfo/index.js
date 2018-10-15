import React from 'react';
import PropTypes from 'prop-types';
// import moment from 'moment';
import prettyBytes from 'pretty-bytes';
import { isNil } from 'lodash';
import classNames from 'classnames';
import './index.styl';

const Container = ({ children, className, ...props }) => (
  <div {...props} className={classNames('file-placeholder-info', className)}>
    {children}
  </div>
);

// eslint-disable-next-line react/no-multi-comp, complexity
const FilePlaceholderInfo = ({
  className,
  uploadedAt,
  uploadedBy,
  size,
  progress,
  description,
  processing,
  failed,
}) => {
  if (failed) {
    return <Container className={className}>Upload failed.</Container>;
  }
  if (description) {
    return <Container className={className}>{description}</Container>;
  }
  if (progress && !processing) {
    return <Container className={className}>{`Uploading...${Math.floor(progress * 100)}%`}</Container>;
  }
  if (progress === 1 && processing) {
    return (
      <Container className={className}>
        <span className='file-placeholder-info-processing'>
          Processing uploaded file...
        </span>
      </Container>
    );
  }
  return (
    <Container className={className}>
      <div>
        {/*uploadedAt ? <span>{moment(uploadedAt).format('YYYY/MM/DD hh:mm A')}</span> : null*/}
        {!isNil(size) && !isNaN(size) ? <span>{prettyBytes(size)}</span> : null}
        {uploadedBy ? <span>Upload by <span className='uploaded-by'>{uploadedBy}</span></span> : null}
      </div>
    </Container>
  );
};

FilePlaceholderInfo.propTypes = {
  uploadedAt: PropTypes.string,
  uploadedBy: PropTypes.string,
  size: PropTypes.number,
  progress: PropTypes.number,
  description: PropTypes.string,
  processing: PropTypes.bool,
  failed: PropTypes.bool,
};

export default FilePlaceholderInfo;
