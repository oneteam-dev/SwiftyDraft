import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import { TogglePattern } from 'react-toggle-pattern';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import mapFileIcon from '../../../helpers/mapFileIcon';
import FilePlaceholderInfo from './FilePlaceholderInfo';
import FilePlaceholderAction from './FilePlaceholderAction';
import FilePlaceholderProgressBar from './FilePlaceholderProgressBar';
import FilePlaceholderRemove from './FilePlaceholderRemove';
import './index.styl';

const FilePlaceholder = ({ // eslint-disable-line complexity
  id,
  url,
  name,
  progress,
  onRendered,
  showDownload,
  failed,
  contentType,
  containerTagName: ContainerClass,
  uploadedAt,
  uploadedBy,
  size,
  description,
  processing,
  onRemove,
  className,
  onRetry,
}) => {
  const isAnchor = ContainerClass === 'a';
  const fileIcon = mapFileIcon(contentType, name);
  const canDownload = showDownload && !failed;
  return (
    <ContainerClass
      className={classNames('file-placeholder', className, { downloadable: canDownload, failed })}
      ref={el => typeof onRendered === 'function' && onRendered(el)}
      href={isAnchor ? url : undefined}
      target={isAnchor ? '_blank' : undefined}
      download={isAnchor ? true : false}
    >
      <div className='file-icon'>
        <img src={require(`../../../images/file-icons/${fileIcon}.png`)} />
      </div>
      <FilePlaceholderAction
        className='right-side'
        id={id}
        canDownload={canDownload}
        failed={failed}
        url={url}
        onRetry={onRetry}
      />
      <div className='main'>
        <div className='name'>{name}</div>
        <FilePlaceholderInfo
          className='info'
          uploadedAt={uploadedAt}
          uploadedBy={uploadedBy}
          size={size}
          progress={progress}
          description={description}
          processing={processing}
          failed={failed}
        />
      </div>
      <TogglePattern hasProgress>
        <FilePlaceholderProgressBar hasProgress={typeof progress === 'number'} progress={progress} />
      </TogglePattern>
      <TogglePattern showRemoveButton>
        <FilePlaceholderRemove
          showRemoveButton={typeof onRemove === 'function'}
          onClick={onRemove}
        />
      </TogglePattern>
    </ContainerClass>
  );
};

FilePlaceholder.propTypes = {
  id: PropTypes.string.isRequired,
  url: PropTypes.string,
  name: PropTypes.string,
  uploadedAt: PropTypes.string,
  uploadedBy: PropTypes.string,
  size: PropTypes.number,
  contentType: PropTypes.string,
  progress: PropTypes.number,
  description: PropTypes.string,
  onRendered: PropTypes.func,
  showDownload: PropTypes.bool,
  failed: PropTypes.bool,
  containerTagName: PropTypes.string,
  processing: PropTypes.bool,
  className: PropTypes.string,
  onRemove: PropTypes.func,
};

FilePlaceholder.defaultProps = {
  name: 'Untitled',
  showDownload: true,
  containerTagName: 'a',
};

// eslint-disable-next-line react/no-multi-comp
class WrappedFilePlaceholder extends Component {
  handleElementRendered(elem) {
    if (!elem) {
      return;
    }
    const node = elem.parentNode.parentNode;
    if (node) {
      const listener = () => {
        node.removeEventListener('DOMNodeRemoved', listener);
        ReactDOM.unmountComponentAtNode(elem.parentNode);
      };
      node.addEventListener('DOMNodeRemoved', listener);
    }
  }
  render() {
    return <FilePlaceholder {...this.props} onRendered={this.handleElementRendered} />;
  }
}

/**
 * <file-placeholder url="" name="" uploaded-at="" uploaded-by="" size="" content-type="">
 *   <a href="" target="_blank" download>File name</a>
 * </file-placeholder>
 */
export const renderFilePlaceholders = elements => {
  Array.from(elements).forEach((element, i) => {
    if (element.querySelectorAll('.file-placeholder').length === 0) {
      const url = element.getAttribute('url');
      const props = {
        url,
        id: `${url}-${i}`,
        name: element.getAttribute('name'),
        uploadedAt: element.getAttribute('uploaded-at'),
        uploadedBy: element.getAttribute('uploaded-by'),
        size: parseInt(element.getAttribute('size'), 10),
        contentType: element.getAttribute('content-type')
      };
      ReactDOM.render(<WrappedFilePlaceholder {...props} />, element);
    }
  });
};

export default FilePlaceholder;
