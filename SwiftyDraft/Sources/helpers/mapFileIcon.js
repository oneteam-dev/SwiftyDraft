import mime from 'mime-types';

export default function mapFileIcon(contentType, fileName) { // eslint-disable-line complexity
  if (isExcel(contentType)) {
    return 'xls';
  }

  if (isPowerPoint(contentType)) {
    return 'ppt';
  }

  if (isWord(contentType)) {
    return 'doc';
  }

  if (isAudio(contentType)) {
    return 'audio';
  }

  if (isVideo(contentType)) {
    return 'video';
  }

  if (isImage(contentType)) {
    return 'image';
  }

  if (isPSD(contentType)) {
    return 'psd';
  }

  if (isCompressed(contentType)) {
    return 'zip';
  }

  if (isSketch(fileName)) {
    return 'sketch';
  }

  if (isIllustrator(fileName)) {
    return 'ai';
  }

  if (isHTML(fileName)) {
    return 'html';
  }

  if (isJS(contentType, fileName)) {
    return 'js';
  }

  if (isMarkdown(contentType, fileName)) {
    return 'md';
  }

  const ext = mime.extension(contentType);
  return existingIconNames.includes(ext) ? ext : 'unknown';
}

const existingIconNames = [
  'ai', 'audio', 'csv', 'doc', 'gdoc', 'gsheet', 'gslides', 'html', 'image', 'js', 'md', 'pdf', 'ppt', 'psd',
  'sketch', 'txt', 'video', 'xls', 'zip'
];

const excelContentTypes = [
  'application/vnd.ms-excel',
  'application/vnd.ms-excel.addin.macroenabled.12',
  'application/vnd.ms-excel.sheet.binary.macroenabled.12',
  'application/vnd.ms-excel.sheet.macroenabled.12',
  'application/vnd.ms-excel.template.macroenabled.12',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheetmetadata+xml'
];
const isExcel = contentType => excelContentTypes.includes(contentType);

const powerpointContentTypes = [
  'application/vnd.ms-powerpoint',
  'application/vnd.ms-powerpoint.addin.macroenabled.12',
  'application/vnd.ms-powerpoint.presentation.macroenabled.12',
  'application/vnd.ms-powerpoint.slide.macroenabled.12',
  'application/vnd.ms-powerpoint.slideshow.macroenabled.12',
  'application/vnd.ms-powerpoint.template.macroenabled.12',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml'
];
const isPowerPoint = contentType => powerpointContentTypes.includes(contentType);

const wordContentTypes = [
  'application/msword',
  'application/vnd.ms-word.document.macroenabled.12',
  'application/vnd.ms-word.template.macroenabled.12',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document.glossary+xml',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml'
];
const isWord = contentType => wordContentTypes.includes(contentType);

const compressedContentTypeRegex =
/^application\/(.+-archive|(g|b)?zip|x-((sh(ar)?|stuffitx?|tar|compress)|\.+-compressed))$/;
const isCompressed = contentType => compressedContentTypeRegex.test(contentType);

const isAudio = contentType => /^audio\/\S+$/.test(contentType);
const isVideo = contentType => /^video\/\S+$/.test(contentType);
const isPSD = contentType => /^image\/(vnd\.adobe\.photoshop|x-photoshop)$/.test(contentType);
const isImage = contentType => !isPSD(contentType) && /^image\/\S+$/.test(contentType);
const isSketch = name => /\.sketch$/.test(name);
const isHTML = name => /\.(html?|shtml|xht(ml)?)$/.test(name);
const isIllustrator = name => /\.ai$/.test(name);
const isJS = (contentType, name) => contentType === 'text/javascript' || /\.js$/.test(name);
const isMarkdown = (contentType, name) => contentType === 'text/markdown' || /\.md$/.test(name);
