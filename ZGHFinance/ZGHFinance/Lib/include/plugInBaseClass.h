//
//  plugInBaseClass.h
//  19pay_p2p_SDK_code
//
//  Created by Seth Cheng on 15/7/20.
//  Copyright (c) 2015年 19pay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnResultDelegate.h"

@interface plugInBaseClass : UIViewController

@property(nonatomic,weak)id<ReturnResultDelegate> delegate;
@property(nonatomic,strong)UIColor *navigationBarColor;

/*
 *获取商户的资金托管类型
 */
- (void)getMerchantCapitalSaveTypeWithInfo:(NSDictionary *)merchantInfo;
/*
 *MD5签名方法
 */
- (NSString *)getMD5WithPram:(NSString *)pram withKey:(NSString *)key;

/*
 *获得当前日期时间方法
 */
- (NSString *)getCurrentTime;

/*1
 *注册接口
 */
- (void)registerInterfaceWithMerchantId:(NSString *)merchantId
                          merchantIdSrc:(NSString *)merchantIdSrc
                                 reqSno:(NSString *)reqSno
                                reqTime:(NSString *)reqTime
                            callBackUrl:(NSString *)callBackUrl
                                 userId:(NSString *)userId
                               userName:(NSString *)userName
                                   idNo:(NSString *)idNo
                                  phone:(NSString *)phone
                             bankCardNo:(NSString *)bankCardNo
                                  email:(NSString *)email;
/*2
 *充值
 */
- (void)topUpInterfaceWithMerchantId:(NSString *)merchantId
                       merchantIdSrc:(NSString *)merchantIdSrc
                              reqSno:(NSString *)reqSno
                             reqTime:(NSString *)reqTime
                         callBackUrl:(NSString *)callBackUrl
                           accountNo:(NSString *)accountNo
                              amount:(NSString *)amount
                     bindBankCardSno:(NSString *)bindBankCardSno;
/*3
 *提现
 */
- (void)takeCashInterfaceWithMerchantId:(NSString *)merchantId
                          merchantIdSrc:(NSString *)merchantIdSrc
                                 reqSno:(NSString *)reqSno
                                reqTime:(NSString *)reqTime
                            callBackUrl:(NSString *)callBackUrl
                              accountNo:(NSString *)accountNo
                                 amount:(NSString *)amount
                                    fee:(NSString *)fee
                                bindSno:(NSString *)bindSno
                                accType:(NSString *)accType;
/*4
 *投资
 */
- (void)investmentInterfaceWithMerchantId:(NSString *)merchantId
                            merchantIdSrc:(NSString *)merchantIdSrc
                                   reqSno:(NSString *)reqSno
                                  reqTime:(NSString *)reqTime
                              callBackUrl:(NSString *)callBackUrl
                                accountNo:(NSString *)accountNo
                              projectCode:(NSString *)projectCode
                                   amount:(NSString *)amount
                      isUserMarketingFund:(NSString *)isUserMarketingFund
                              mxAccountNo:(NSString *)mxAccountNo
                          mxMarketingFund:(NSString *)mxMarketingFund;
/*5
 *认购
 */
- (void)purchareInterfaceWithMerchantId:(NSString *)merchantId
                          merchantIdSrc:(NSString *)merchantIdSrc
                                 reqSno:(NSString *)reqSno
                                reqTime:(NSString *)reqTime
                            callBackUrl:(NSString *)callBackUrl
                             assignCode:(NSString *)assignCode
                              buyCustId:(NSString *)buyCustId
                            assignAmont:(NSString *)assignAmont
                              payAmount:(NSString *)payAmount
                     isUseMarketingFund:(NSString *)isUseMarketingFund
                            mxAccountNo:(NSString *)mxAccountNo
                        mxMarketingFund:(NSString *)mxMarketingFund;

/*6
 *授权
 */
- (void)authorizeInterfaceWithMerchantId:(NSString *)merchantId
                           merchantIdSrc:(NSString *)merchantIdSrc
                                  reqSno:(NSString *)reqSno
                                 reqTime:(NSString *)reqTime
                             callBackUrl:(NSString *)callBackUrl
                               accountNo:(NSString *)accountNo
                                  amount:(NSString *)amount
                             companyName:(NSString *)companyName
                         authorizeReason:(NSString *)authorizeReason;

/*7
 *还款
 */
- (void)returnMoneyInterfaecWithMerchantId:(NSString *)merchantId
                             merchantIdSrc:(NSString *)merchantIdSrc
                                    reqSno:(NSString *)reqSno
                                   reqTime:(NSString *)reqTime
                               callBackUrl:(NSString *)callBackUrl
                                 accountNo:(NSString *)accountNo
                               projectCode:(NSString *)projectCode
                                    amount:(NSString *)amount
                               repayCorpus:(NSString *)repayCorpus
                               repayDetail:(NSArray *)repayDetail
                                     isEnd:(NSString *)isEnd;
/*8
 *转帐
 */
- (void)transferCapitalInterfaecWithMerchantId:(NSString *)merchantId
                                 merchantIdSrc:(NSString *)merchantIdSrc
                                        reqSno:(NSString *)reqsno
                                       reqTime:(NSString *)reqTime
                                   callBackUrl:(NSString *)callBackUrl
                                 accountNoFrom:(NSString *)accountNoFrom
                                   accountNoTo:(NSString *)accountNoTo
                                   tradeAmount:(NSString *)tradeAmount
                                     tradeDesc:(NSString *)tradeDesc;
/*9
 *债权转让
 */
- (void)cessionOfClaimInterfaecWithMerchantId:(NSString *)merchantId
                                merchantIdSrc:(NSString *)merchantIdSrc
                                       reqSno:(NSString *)reqsno
                                      reqTime:(NSString *)reqTime
                                  callBackUrl:(NSString *)callBackUrl
                                    accountNo:(NSString *)accountNo
                                  projectCode:(NSString *)projectCode
                                   assignCode:(NSString *)assignCode
                                   assignType:(NSString *)assignType
                                       amount:(NSString *)amountStr
                                   amountNeed:(NSString *)amountNeedStr;


/*10
 *修改支付密码接口
 */
- (void)modifyPayPWDInterfaceWithMerchantId:(NSString *)merchantId
                              merchantIdSrc:(NSString *)merchantIdSrc
                                     reqSno:(NSString *)reqSno
                                    reqTime:(NSString *)reqTime
                                callBackUrl:(NSString *)callBackUrl
                                  accountNo:(NSString *)accountNo;
/*11
 *找回支付密码接口
 */
- (void)findPayPWDInterfaceWithMerchantId:(NSString *)merchantId
                            merchantIdSrc:(NSString *)merchantIdSrc
                                   reqSno:(NSString *)reqSno
                                  reqTime:(NSString *)reqTime
                              callBackUrl:(NSString *)callBackUrl
                                accountNo:(NSString *)accountNo;













@end
