import React, { Component } from 'react';
// import { injectIntl, intlShape } from 'react-intl';
import PropTypes from 'prop-types';
import isFunction from 'lodash/isFunction';
import FilePlaceholder from '.';
import SvgIcon from '../SvgIcon';
// import FilesActionCreators from 'actions/FilesActionCreators';
// import FileUploadStatusStore from 'stores/FileUploadStatusStore';

class FilePlaceholderWithProgress extends Component {
  handleStatusCreation = data => { // eslint-disable-line complexity
    const { name, contentType, description, file, progress, id } = data;
    if (this.props.id === id) {
      this.setState({ progress });
      if (this.isFinish(data)) {
        // eslint-disable-next-line no-alert
        setTimeout(() => alert(this.props.intl.formatMessage({ id: 'file.error.size' })), this.transitionDelayTime);
        this.onFinish(data);
      } else {
        // FilesActionCreators.createKey({ id, file, name, contentType, description: description || name });
      }
    }
  }
  handleStatusUpdateWithCreateKey = data => {
    if (this.props.id === data.id) {
      this.setState({ progress: data.progress });
      // FilesActionCreators.upload(data);
    }
  }
  handleStatusUpdate = data => { // eslint-disable-line complexity
    if (this.props.id === data.id) {
      this.setState({ progress: data.progress });
      const finished = this.isFinish(data);
      if (!data.polling && !finished) {
        this.getByPolling(data);
      } else if (data.progress >= 1 && finished) {
        this.onFinish(data);
      }
    }
  }
  onFinish(data) {
    // Wait 500ms for animation of progress bar
    this._timeoutId = setTimeout(() => {
      if (isFunction(this.props.onFinish)) {
        this.props.onFinish(data);
      }
      // FilesActionCreators.deleteStatus(data);
    }, this.transitionDelayTime);
  }
  constructor(props) {
    super(props);
    this.state = { progress: null };
  }
  componentDidMount() { // eslint-disable-line complexity
    if (this.isFinish(this.props)) {
      return;
    }
    // FileUploadStatusStore.addCreationListener(this.handleStatusCreation);
    // FileUploadStatusStore.addUpdateWithCreateKeyListener(this.handleStatusUpdateWithCreateKey);
    // FileUploadStatusStore.addUpdateListener(this.handleStatusUpdate);

    let data;
    // if (data = FileUploadStatusStore.data[this.props.id]) {
    //   this.setState({ progress: data.progress });
    //   this.getByPolling(data);
    //   return;
    // }

    if (!data) {
      // FilesActionCreators.createStatus(this.props);
      return;
    }

    if (!data.key) {
      const { name, contentType, description } = this.props;
      // FilesActionCreators.createKey({ name, contentType, description: description || name });
      return;
    }

    if (!data.uploaded) {
      // FilesActionCreators.upload(this.props.file);
    }
  }
  componentWillUnmount() {
    clearTimeout(this._timeoutId);

    if (this.isFinish(this.props)) {
      // FilesActionCreators.deleteStatus(this.props);
      return;
    }
    FileUploadStatusStore.removeCreationListener(this.handleStatusCreation);
    FileUploadStatusStore.removeUpdateWithCreateKeyListener(this.handleStatusUpdateWithCreateKey);
    FileUploadStatusStore.removeUpdateListener(this.handleStatusUpdate);
    // FilesActionCreators.stopPolling(FileUploadStatusStore.data[this.props.id], this._key);
  }
  getByPolling(data) {
    // FilesActionCreators
    // .getByPolling(data, this._key = data.key)
    // .catch(error => {
    //   // Wait 500ms for animation of progress bar
    //   setTimeout(
    //     () => alert(this.props.intl.formatMessage({ id: error.key })), // eslint-disable-line no-alert
    //     this.transitionDelayTime
    //   );
    // });
  }
  pickFilePlaceholderProps() {
    const { id, download_url, name, created_by, created_at, size, contentType, status } = this.props;
    return {
      id,
      url: download_url,
      uploadedAt: status === 'completed' && created_at ? created_at : undefined,
      uploadedBy: created_by ? created_by.name : undefined,
      name, size, contentType
    };
  }
  renderDelete() {
    return <span
      onClick={this.props.onDelete}
      className='file-placeholder-delete'><SvgIcon name='close-wh' /></span>;
  }
  renderFilePlaceholder() {
    return (
      <FilePlaceholder
        {...this.pickFilePlaceholderProps()}
        showDownload={false}
        description={this.failed ? 'Upload failed.' : undefined}
        failed={this.failed}
        progress={this.progress()}
        containerTagName='div' />
    );
  }
  render() {
    return <div className='file-placeholder-with-progress'>
      {this.renderFilePlaceholder()}
      {this.renderDelete()}
    </div>;
  }
  isFinish({ status, timeout, error }) { // eslint-disable-line complexity
    return status === 'completed' || status === 'failed' || !!timeout || !!error;
  }
  progress() { // eslint-disable-line complexity
    if (!this.props.status) {
      return this.state.progress;
    }
    if (this.props.status === 'failed' || this.props.status === 'uploading') {
      return this.props.progress;
    }
  }
  get failed() {
    const { status, timeout, error } = this.props;
    return status === 'failed' || !!timeout || !!error;
  }
  get transitionDelayTime() {
    return 500;
  }
  static propTypes = {
    // intl: intlShape.isRequired,
    intl: PropTypes.isRequired,
    onFinish: PropTypes.func
  }
}

// export default injectIntl(FilePlaceholderWithProgress);
export default FilePlaceholderWithProgress;
