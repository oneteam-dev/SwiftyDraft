/*eslint-env node */
import path from 'path';
import bootstrap from 'bootstrap-styl';
import webpack from 'webpack';

const entry = [
  'webpack/hot/only-dev-server',
  'react-hot-loader/patch',
  'babel-polyfill',
  './SwiftyDraft/Sources/index.js'
];
const plugins = [
  new webpack.HotModuleReplacementPlugin()
];

export default {
  plugins,
  entry,
  cache: true,
  output: {
    path: path.resolve(__dirname, 'SwiftyDraft/Assets'),
    filename: 'bundle.js'
  },
  display: { errorDetails: true },
  resolve: {
    extensions: ['', '.js']
  },
  stylus: {
    use: [bootstrap()]
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
      },
      {
        test: /\.css$/,
        loaders: ['style', 'css']
      },
      {
        test: /\.styl$/,
        loaders: ['style', 'css', 'stylus']
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff'
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader'
      }
    ]
  }
};
