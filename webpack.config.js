/*eslint-env node */
const path = require('path');
const bootstrap = require('bootstrap-styl');
const stylusLoader = require('stylus-loader');

const entry = ['@babel/polyfill', './SwiftyDraft/Sources/index.js'];
const plugins = [
  new stylusLoader.OptionsPlugin({
    default: {
      use: [bootstrap()]
    }
  })
];

module.exports = {
  plugins,
  entry,
  cache: true,
  output: {
    path: path.resolve(__dirname, 'SwiftyDraft/Assets'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.styl$/,
        use: ['style-loader', 'css-loader', 'stylus-loader']
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader',
        options: { limit: 10000, mimetype: 'application/font-woff' }
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: ['file-loader']
      },
      {
        test: /\.png$/,
        loader: 'url-loader',
        options: { limit: 10000 }
      }
    ]
  }
};
