import { NativeModules, Platform } from 'react-native'

const { movToMp4 } = NativeModules

export function convertMovToMp4(filename, quality="medium") {
    if (Platform.OS === "ios") {
        const dest = filename.split("/").slice(-1)[0].replace(".mov", ".mp4")
        return movToMp4.convertMovToMp4(filename, dest, quality)
    } else {
        return new Promise(function(resolve, reject) {
            resolve([filename])
        })
    }
}