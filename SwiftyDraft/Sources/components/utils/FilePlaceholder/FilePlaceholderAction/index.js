import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import FilePlaceholderDownload from '../FilePlaceholderDownload';
import FilePlaceholderRetryButton from '../FilePlaceholderRetryButton';

const FilePlaceholderAction = ({ className, id, canDownload, failed, url, onRetry }) => {
  return (
    <div className={classNames('file-placeholder-action', className)}>
      {failed && typeof onRetry === 'function' ? (
        <FilePlaceholderRetryButton onClick={onRetry}>Try again</FilePlaceholderRetryButton>
      ) : (
        canDownload && url ? <FilePlaceholderDownload id={id} url={url} /> : null
      )}
    </div>
  );
};

FilePlaceholderAction.propTypes = {
  id: PropTypes.string,
  className: PropTypes.string,
  canDownload: PropTypes.bool,
  failed: PropTypes.bool,
  url: PropTypes.string,
  onRetry: PropTypes.func,
};

export default FilePlaceholderAction;
