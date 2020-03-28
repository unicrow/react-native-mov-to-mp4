// / <reference types="react" />

declare module 'react-native-mov-to-mp4' {
    export function convertMovToMp4(filename:string, quality:"medium"|"low"|"high") : Promise<[string]>
}