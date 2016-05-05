/*eslint-env node */
import path from 'path';
import bootstrap from 'bootstrap-styl';

const entry = ['./SwiftyDraft/Sources/index.js'];
const plugins = [];

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
        query: { presets: ['es2015', 'react'] }
      },
      {
        test: /\.css$/,
        loaders: ['style', 'css']
      },
      {
        test: /\.styl$/,
        loaders: ['style', 'css', 'stylus']
      }
    ]
  }
};
