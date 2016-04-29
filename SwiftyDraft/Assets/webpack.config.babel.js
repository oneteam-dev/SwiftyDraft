import path from 'path';
import webpack from 'webpack';
import bootstrap from 'bootstrap-styl';

const entry = ['./src/index.js'];
const plugins = [];

export default {
  plugins,
  entry,
  cache: true,
  output: {
    path: path.resolve(__dirname, 'dist'),
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
