import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import SvgIcon from '../../SvgIcon';
import './index.styl';

const FilePlaceholderRemove = ({ onClick, className }) => {
  return (
    <span onClick={onClick} className={classNames('file-placeholder-remove', className)}>
      {/*<SvgIcon name='close-wh' />*/}
      Tap to Delete
    </span>
  );
};

FilePlaceholderRemove.propTypes = {
  onClick: PropTypes.func,
  className: PropTypes.string,
};

export default FilePlaceholderRemove;
