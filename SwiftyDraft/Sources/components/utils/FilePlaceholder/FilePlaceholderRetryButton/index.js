import React from 'react';
import PropTypes from 'prop-types';
import { Button } from 'react-bootstrap';
import classNames from 'classnames';

const FilePlaceholderRetryButton = ({ className, children, ...props }) => {
  return (
    <Button
      {...props}
      className={classNames('file-placeholder-retry-button', className)}
    >
      {children}
    </Button>
  );
};

FilePlaceholderRetryButton.propTypes = {
  className: PropTypes.string,
  children: PropTypes.node,
};

export default FilePlaceholderRetryButton;
