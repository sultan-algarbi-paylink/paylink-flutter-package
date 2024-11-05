## 2.0.1

**Fixed**

- Updated `PaylinkGatewayOrderRequest.fromMap` constructor to handle flexible casting for the `products` list.
  - Previously, `data['products']` expected a `List<Map<String, dynamic>>` type, which caused runtime errors when provided with a generic `List<dynamic>`.
  - Modified the casting to use `List<dynamic>` and added explicit casting of each element to `Map<String, dynamic>` within the `map` function.
  - This change ensures compatibility with varied list types and prevents runtime errors related to type mismatches.

## 2.0.0

- **Improved Authentication Workflow**

  - Authentication now occurs only when necessary, ensuring the token is refreshed when `idToken` is null, reducing unnecessary API calls.

- **Enhanced Invoice Management**

  - **Optional Parameters Handling**: Parameters like `clientEmail`, `cancelUrl`, and `supportedCardBrands` are now handled more gracefully, ensuring better flexibility.
  - **Brand Filtering**: `supportedCardBrands` are filtered to include only valid entries as per `PaylinkConstants.validCardBrands`.
  - **Product Mapping**: `PaylinkProduct` objects are now converted into a structured map for better API integration.

- **Advanced Error Handling**

  - Enhanced error extraction from API responses, providing more detailed error messages.
  - The `_handleResponseError` method now includes the HTTP status code in the error message, making debugging easier.

- **Flutter Webview Integration**

  - **New `openPaymentForm` Method**: Streamlined payment handling with clear callbacks for payment success (`onPaymentComplete`) and error handling (`onError`).
  - **Improved `_showWebView` Method**: Modularized the webview logic for displaying the payment form, improving clarity and maintainability.
  - **Callback Management**: The `handleCallbackReached` method refines the process of payment completion by handling callback parameters and validating the transaction status.

- **Factory Constructors for Test & Production Environments**

  - Simplified environment setup with dedicated factory constructors:
    - `PaylinkAPI.test` and `PaylinkAPI.production`
    - `PaylinkPayment.test` and `PaylinkPayment.production`

- **Code Refactoring**
  - Refactored code for better modularity and reusability, particularly in the `PaylinkPayment` class, reducing redundancy and improving readability.

## 1.0.4

- Added invoice creation functionality.
- Implemented cancel invoice feature.
- Added ability to retrieve invoice details.

## 1.0.3

- Improve the GitHub Action.

## 1.0.2

- Update the package description.

## 1.0.1

- Enhanced package documentation for better clarity and usability.

## 1.0.0

- Corrected a bug related to callback URL parameters.
- Improved the design of the webview widget for a more user-friendly interface.
- Added the ability to customize webview colors according to user preferences.
- Implemented robust error handlers to handle various scenarios effectively.
- Enhanced error messages for better understanding and troubleshooting.

## 0.9.4

- Optimized API Link and Payment Frame URLs based on the project's environment.
- Incorporated Payment Token for secure and authorized transactions.
- Ensured proper usage of Transaction Number and Order Number for accurate processing.

## 0.9.3

- Introduced a callback function to enhance the payment functionality.

## 0.9.2

- Added a new payment verification feature to ensure transaction integrity.
- Resolved a bug related to transaction handling for smoother operations.

## 0.9.1

- Released the initial version of the Paylink Payment Package with essential features.
