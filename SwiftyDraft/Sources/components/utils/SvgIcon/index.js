import React from 'react';
import PropTypes from 'prop-types';
import './index.styl';

class SvgIcon extends React.Component {
  render() {
    return (
      <img className={'svg-icon icon ' + this.props.name} src={this._svg} onClick={this.props.onClick}/>
    );
  }
  get _svg() {
    return require('../../../images/icons/icon-' + this.props.name + '.svg');
  }
}

SvgIcon.propTypes = {
  name: PropTypes.string.isRequired,
  onClick: PropTypes.func
};

SvgIcon.displayName = 'SvgIcon';

export default SvgIcon;
