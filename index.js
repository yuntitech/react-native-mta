import { NativeModules, Platform } from 'react-native';

const { RNMta } = NativeModules;

/**
 * 初始化 MTA
 * @param  {String}  appKey
 * @param  {String}  [channel='']     渠道，仅 android 有效
 * @param  {Boolean} [isDebug=false}] 是否开启 debug 模式，仅 android 有效
 * @return {Promise}
 */
const startWithAppkey = async ({ appKey, channel = '', isDebug = false }) => {
  return RNMta.startWithAppkey(appKey, channel, isDebug);
};

/**
 * trackPageBegin 跟踪页面开始
 * @param  {String}  page           页面名称
 * @param  {String}  [appKey=null}]
 * @return {Promise}
 */
const trackPageBegin = async ({ page, appKey = null }) => {
  await checkInitialResult();
  return RNMta.trackPageBegin(page, appKey);
};

/**
 * trackPageEnd 跟踪页面结束
 * @param  {String}  page                页面名称
 * @param  {String}  [appKey=null}]
 * @param  {Boolean} [isRealTime=false}] 是否实时上报
 * @return {Promise}
 */
const trackPageEnd = async ({ page, appKey = null, isRealTime = false }) => {
  await checkInitialResult();
  return RNMta.trackPageEnd(page, appKey, isRealTime);
};

/**
 * trackCustomEvent 自定义事件
 * @param  {String}  event              事件名称
 * @param  {Object}  [params={}]        事件参数
 * @param  {String}  [appKey=null]
 * @param  {Boolean} [isRealTime=false] 是否实时上报
 * @return {Promise}
 */
const trackCustomEvent = async ({
  event,
  params = {},
  appKey = null,
  isRealTime = false
}) => {
  await checkInitialResult();
  const result = await RNMta.trackCustomEvent(
    event,
    params,
    appKey,
    isRealTime
  );
  return handleResult(result);
};

/**
 * trackCustomEventBegin 自定义事件开始
 * @param  {String}  event              事件名称
 * @param  {Object}  [params={}]        事件参数
 * @param  {String}  [appKey=null]
 * @return {Promise}
 */
const trackCustomEventBegin = async ({ event, params = {}, appKey = null }) => {
  await checkInitialResult();
  const result = await RNMta.trackCustomEventBegin(event, params, appKey);
  return handleResult(result);
};

/**
 * trackCustomEventEnd 自定义事件结束
 * @param  {String}  event              事件名称
 * @param  {Object}  [params={}]        事件参数
 * @param  {String}  [appKey=null]
 * @param  {Boolean} [isRealTime=false] 是否实时上报
 * @return {Promise}
 */
const trackCustomEventEnd = async ({
  event,
  params = {},
  appKey = null,
  isRealTime = false
}) => {
  await checkInitialResult();
  const result = await RNMta.trackCustomEventEnd(
    event,
    params,
    appKey,
    isRealTime
  );
  return handleResult(result);
};

/**
 * trackCustomEventDuration 自定义事件周期
 * @param  {String}  event              事件名称
 * @param  {Number}  duration          事件周期
 * @param  {Object}  [params={}]        事件参数
 * @param  {String}  [appKey=null]
 * @param  {Boolean} [isRealTime=false] 是否实时上报
 * @return {Promise}
 */
const trackCustomEventDuration = async ({
  event,
  duration,
  params = {},
  appKey = null,
  isRealTime = false
}) => {
  await checkInitialResult();
  const result = await RNMta.trackCustomEventDuration(
    event,
    duration,
    params,
    appKey,
    isRealTime
  );
  return handleResult(result);
};

/**
 * trackActiveBegin 应用进入前台
 * @return {Promise}
 */
const trackActiveBegin = async () => {
  await checkInitialResult();
  if (Platform.OS === 'android') return false;
  return RNMta.trackActiveBegin();
};

/**
 * trackActiveEnd 应用进入后台
 * @return {Promise}
 */
const trackActiveEnd = async () => {
  await checkInitialResult();
  if (Platform.OS === 'android') return false;
  return RNMta.trackActiveEnd();
};

/**
 * setUserProperty 设置自定义参数
 * @param  {Object}  params 自定义参数
 * @return {Promise}
 */
const setUserProperty = async params => {
  await checkInitialResult();
  return RNMta.setUserProperty(params);
};

/**
 * reportAccount 上报单个账号，通常用于登陆/刷票登陆/第三方登陆等时机调用
 * @param  {number}  type      账号类型
 * @param  {String}  id        账号id
 * @return {Promise}
 */
const reportAccount = async ({
  type,
  id
}: {
  type: AccountType,
  id: String
}) => {
  await checkInitialResult();
  return RNMta.reportAccount(type, id);
};

/**
 * removeAccount 根据账号类型删除某个账号，通常用于注销时调用
 * @param  {number}  type      账号类型
 * @return {Promise}
 */
const removeAccount = async (type: AccountType) => {
  await checkInitialResult();
  return RNMta.removeAccount(type);
};

let checkInitialResult = async () => {
  let isInitSuccess = await RNMta.checkInitialResult();
  if (!isInitSuccess) throw Errs.INITIAL_FAILED;
  checkInitialResult = () => true;
  return isInitSuccess;
};

let handleResult = errCode => {
  switch (errCode) {
    case 0:
      return Errs.SUCCESS;
    case -1:
      return Errs.INITIAL_FAILED;
    case 1000:
      return Errs.PARAMS_ERROR;
    case 1001:
      return Errs.PARAMS_OVER_LIMIT;
    default:
      return Errs.UNKNOW;
  }
};

const Errs = {
  SUCCESS: {
    errCode: 0,
    errMsg: ''
  },
  INITIAL_FAILED: {
    errCode: -1,
    errMsg: 'MTA初始化未成功'
  },
  PARAMS_ERROR: {
    errCode: -2,
    errMsg: 'MTA传入参数错误'
  },
  PARAMS_OVER_LIMIT: {
    errCode: -3,
    errMsg: 'MTA传入参数过长'
  },
  UNKNOW: {
    errCode: -9,
    errMsg: '未知错误'
  }
};

const AccountType = {
  PHONE_NO: 1,
  OPEN_WEIXIN: 2,
  OPEN_QQ: 3,
  OPEN_WEIBO: 4
};

export default {
  startWithAppkey,
  setUserProperty,
  trackPageBegin,
  trackPageEnd,
  trackCustomEvent,
  trackCustomEventBegin,
  trackCustomEventEnd,
  trackCustomEventDuration,
  trackActiveBegin,
  trackActiveEnd,
  reportAccount,
  removeAccount,
  AccountType
};
