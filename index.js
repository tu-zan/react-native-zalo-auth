import {
  NativeModules,
  Platform
} from "react-native";

const { RNZalo } = NativeModules;

class Zalo {
  static async login() {
    if (Platform.OS === "ios") {
      try {
        const oauthCode = await RNZalo.login();
        return new Promise((resolve, reject) => {
          RNZalo.getProfile((data) => {
            resolve({
              user: data,
              oauthCode,
              uId: null,
              channel: null
            });
          }, (e) => {
            reject(e);
          });
        });
      } catch (error) {
        throw error;
      }
    }
    return await RNZalo.login();
  }

  static logout() {
    RNZalo.logout();
  }
}

export default Zalo;
