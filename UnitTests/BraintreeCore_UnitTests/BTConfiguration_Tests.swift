import XCTest
import PassKit

class BTConfiguration_Tests: XCTestCase {

    override func tearDown() {
        BTConfiguration.setBetaPaymentOption("venmo", isEnabled: false)
    }
    
    func testInitWithJSON_setsJSON() {
        let json = BTJSON(value: [
            "some": "things",
            "number": 1,
            "array": [1, 2, 3]])
        let configuration = BTConfiguration(json: json)

        XCTAssertEqual(configuration.json, json)
    }

    // MARK: - Beta enabled payment option
    
    func testIsBetaEnabledPaymentOption_returnsFalse() {
        XCTAssertFalse(BTConfiguration.isBetaEnabledPaymentOption("venmo"))
    }

    // MARK: - Venmo category methods

    func testIsVenmoEnabled_whenBetaVenmoIsEnabledAndAccessTokenIsPresent_returnsTrue() {
        let configurationJSON = BTJSON(value: [
            "payWithVenmo": [ "accessToken": "some access token" ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)
        
        XCTAssertTrue(configuration.isVenmoEnabled)
    }

    func testIsVenmoEnabled_whenBetaVenmoIsEnabledAndAccessTokenNotPresent_returnsFalse() {
        let configurationJSON = BTJSON(value: [
            "payWithVenmo": [:]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertFalse(configuration.isVenmoEnabled)
    }

    func testVenmoAccessToken_returnsVenmoAccessToken() {
        let configurationJSON = BTJSON(value: [
            "payWithVenmo": [ "accessToken": "some access token" ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.venmoAccessToken, "some access token")
    }

    func testVenmoEnvironment_returnsVenmoEnvironment() {
        let configurationJSON = BTJSON(value: [
            "payWithVenmo": [ "environment": "rockbox" ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.venmoEnvironment, "rockbox")
    }

    func testEnableVenmo_whenDisabled_setsVenmoBetaPaymentOptionToFalse() {
        BTConfiguration.enableVenmo(false)
        XCTAssertFalse(BTConfiguration.isBetaEnabledPaymentOption("venmo"))
    }

    // MARK: - PayPal category methods

    func testIsPayPalEnabled_returnsPayPalEnabledStatusFromConfigurationJSON() {
        for isPayPalEnabled in [true, false] {
            let configurationJSON = BTJSON(value: [ "paypalEnabled": isPayPalEnabled ])
            let configuration = BTConfiguration(json: configurationJSON)

            XCTAssertTrue(configuration.isPayPalEnabled == isPayPalEnabled)
        }
    }

    func testIsPayPalEnabled_whenPayPalEnabledStatusNotPresentInConfigurationJSON_returnsFalse() {
        let configuration = BTConfiguration(json: BTJSON(value: []))
        XCTAssertFalse(configuration.isPayPalEnabled)
    }

    func testIsBillingAgreementsEnabled_returnsBillingAgreementsStatusFromConfigurationJSON() {
        for isBillingAgreementsEnabled in [true, false] {
            let configurationJSON = BTJSON(value: [
                "paypal": [ "billingAgreementsEnabled": isBillingAgreementsEnabled]
                ])
            let configuration = BTConfiguration(json: configurationJSON)
            XCTAssertTrue(configuration.isBillingAgreementsEnabled == isBillingAgreementsEnabled)
        }
    }

    // MARK: - Apple Pay category methods

    func testIsApplePayEnabled_whenApplePayStatusFromConfigurationJSONIsAString_returnsTrue() {
        for applePayStatus in ["mock", "production", "asdfasdf"] {
            let configurationJSON = BTJSON(value: [
                "applePay": [ "status": applePayStatus ]
                ])
            let configuration = BTConfiguration(json: configurationJSON)

            XCTAssertTrue(configuration.isApplePayEnabled)
        }
    }

    func testIsApplePayEnabled_whenApplePayStatusFromConfigurationJSONIsGarbage_returnsFalse() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "status": 3.14 ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertFalse(configuration.isApplePayEnabled)
    }

    func testIsApplePayEnabled_whenApplePayStatusFromConfigurationJSONIsOff_returnsFalse() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "status": "off" ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertFalse(configuration.isApplePayEnabled)
    }

    func testApplePayCountryCode_returnsCountryCode() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "countryCode": "US" ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.applePayCountryCode!, "US")
    }

    func testApplePayCurrencyCode_returnsCurrencyCode() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "currencyCode": "USD" ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.applePayCurrencyCode!, "USD")
    }

    func testApplePayMerchantIdentifier_returnsMerchantIdentifier() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "merchantIdentifier": "com.merchant.braintree-unit-tests" ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.applePayMerchantIdentifier!, "com.merchant.braintree-unit-tests")
    }

    func testApplePaySupportedNetworks_returnsSupportedNetworks() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "supportedNetworks": ["visa", "mastercard", "amex"] ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.applePaySupportedNetworks!, [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex])
    }

    @available(iOS 9.0, *)
    func testApplePaySupportedNetworks_whenSupportedNetworksIncludesDiscover_returnsSupportedNetworks() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "supportedNetworks": ["discover"] ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.applePaySupportedNetworks!, [PKPaymentNetwork.discover])
    }

    @available(iOS 12.0, *)
    func testApplePaySupportedNetworks_whenSupportedNetworksIncludesMaestro_returnsSupportedNetworks() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "supportedNetworks": ["maestro"] ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.applePaySupportedNetworks!, [PKPaymentNetwork.maestro])
    }

    func testApplePaySupportedNetworks_doesNotPassesThroughUnknownValuesFromConfiguration() {
        let configurationJSON = BTJSON(value: [
            "applePay": [ "supportedNetworks": ["ChinaUnionPay", "Interac", "PrivateLabel"] ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.applePaySupportedNetworks!, [])

    }

    // MARK: - UnionPay category methods

    func testIsUnionPayEnabled_whenUnionPayEnabledFromConfigurationJSONIsTrue_returnsTrue() {
        let configurationJSON = BTJSON(value: [
            "unionPay": [ "enabled": true ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertTrue(configuration.isUnionPayEnabled)
    }

    func testIsUnionPayEnabled_whenUnionPayEnabledFromConfigurationJSONIsFalse_returnsFalse() {
        let configurationJSON = BTJSON(value: [
            "unionPay": [ "enabled": false ]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertFalse(configuration.isUnionPayEnabled)

    }

    func testIsUnionPayEnabled_whenUnionPayEnabledFromConfigurationJSONIsMissing_returnsFalse() {
        let configurationJSON = BTJSON(value: [])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertFalse(configuration.isUnionPayEnabled)
    }

    // MARK: - PaymentFlow ThreeDSecure category methods

    func testIsCardinalAuthenticationJWTReturned_whenCardinalAuthenticationJWTIsPresent() {
        let configurationJSON = BTJSON(value: [
            "threeDSecure": [ "cardinalAuthenticationJWT" : "123"]
            ])
        let configuration = BTConfiguration(json: configurationJSON)

        XCTAssertEqual(configuration.cardinalAuthenticationJWT, "123")
    }

    func testIsGraphQLEnabled_whenGraphQLURLExistsAndIsntEmpty_returnsTrue() {
        let configurationJSON = BTJSON(value: [
            "graphQL": [
                "url": "https://graphql.com"
            ]
        ])
        let configuration = BTConfiguration(json: configurationJSON)
        XCTAssertTrue(configuration.isGraphQLEnabled)
    }
    
    func testIsGraphQLEnabled_whenGraphQLURLIsMissing_returnsFalse() {
        let configurationJSON = BTJSON(value: [
            "graphQL": [
                "url": nil
            ]
        ])
        let configuration = BTConfiguration(json: configurationJSON)
        XCTAssertFalse(configuration.isGraphQLEnabled)
    }
}
