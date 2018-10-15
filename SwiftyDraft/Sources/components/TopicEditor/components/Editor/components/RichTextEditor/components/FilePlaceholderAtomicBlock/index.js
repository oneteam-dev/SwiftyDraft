import React, { Component } from 'react';
import FilePlaceholder from '../../../../../../../utils/FilePlaceholder/Progressable';
import './index.styl';

export default class FilePlaceholderAtomicBlock extends Component {
  handleFinish = data => {
    this.props.blockProps.onComplete(data);
  }
  render() {
    return (
      <div className='file-placeholder-atomic-block'>
        {this.props.blockProps.isImage && this.completed ? this.renderImage() : this.renderFilePlaceholder()}
      </div>
    );
  }
  renderFilePlaceholder() {
    // return <div className={this.shouldShowPdfPreviewPlaceholder ? 'with-pdf-preview' : ''}>
    return <div className='with-pdf-preview'>
      <FilePlaceholder id={this.props.blockProps.url} {...this.props.blockProps} onFinish={this.handleFinish} />
      {this.shouldShowPdfPreviewPlaceholder ? (
        <div className='with-pdf-preview-description'>File preview will show in here after you posted.</div>
      ) : null}
    </div>;
  }
  renderImage() {
    const { blockProps, ImageComponent } = this.props;
    return <ImageComponent blockProps={blockProps} />;
  }
  get isPdfPreview() {
    const { contentType, thumbnails } = this.props.blockProps;
    return contentType === 'application/pdf' ||
      (thumbnails && thumbnails.preview && thumbnails.preview.content_type === 'application/pdf');
  }
  get completed() {
    return this.props.blockProps.status === 'completed';
  }
  get shouldShowPdfPreviewPlaceholder() {
    return false;
    // return this.isPdfPreview && this.completed;
  }
}
