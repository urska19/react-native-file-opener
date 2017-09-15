'use strict';

const React = require('react-native');
const FileOpener = React.NativeModules.FileOpener;
import {Platform} from 'react-native';

module.exports = {
	open(filePath, fileMine, iPadPositionX, iPadPositionY, iPadPositionWidth, iPadPositionHeight) {
		return new Promise(function(resolve, reject) {
			if(Platform.OS == 'ios') {
				FileOpener.open(filePath, fileMine, iPadPositionX, iPadPositionY, iPadPositionWidth, iPadPositionHeight).then(() => resolve(), (err) => reject(err));
			} else {
				FileOpener.open(filePath, fileMine).then(() => resolve(), (err) => reject(err));
			}

		})
	},
	FileOpener: FileOpener,
};