import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import './index.styl';

const FilePlaceholderProgressBar = ({ progress, className }) => {
  return (
    <div className={classNames('progress-bar-container', className)}>
      <div className='progress-bar' style={{ width: `${progress * 100}%` }} />
    </div>
  );
};

FilePlaceholderProgressBar.propTypes = {
  progress: PropTypes.number,
  className: PropTypes.string,
};

export default FilePlaceholderProgressBar;
