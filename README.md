# StockBalance

### Program Description
StockBalance is an iOS application for analyzing stock ownership with several features including:
- Display stock ownership of selected stock in a chart
- Save stock in watchlist based on user account
- Filter stock with changing scriptless shares over the past month
- Filter stock with inrceasing or descreasing ownership of certain shareholder type in a stock

## Related Repositories
- **iOS Application**: https://github.com/RichSvK/StockBalance
- **API Gateway**: https://github.com/RichSvK/API_Gateway
- **User and Watchlist services**: https://github.com/RichSvK/User_Backend
- **Stock Services**: https://github.com/RichSvK/Stock_Backend

### System Requirements
Software used in developing this program:
- Swift
- SwiftUI
- Charts
- Foundation

### Program Setup
1. Clone all of the backend systems, insert all required data, and run them
2. Clone this repository
3. Create `Secrets.plist` and set the `BACKEND_HOST` url
   <img width="2316" height="260" alt="image" src="https://github.com/user-attachments/assets/326f0960-5b8c-428e-8494-7a6dcc205886" />
4. Build in Xcode

### View
1. Stock Watchlist <br>
   The **Stock Watchlist** view displays the user’s stock watchlist with a search bar to search stocks. <br>
   <img width="200" height="534" alt="image" src="https://github.com/user-attachments/assets/b12de21c-eb18-4ee9-8672-b94212179867" />

2. Stock Search <br>
   The **Stock Search** view displays list of stock based on the entered searched text. <br>
   <img width="200" height="534" alt="image" src="https://github.com/user-attachments/assets/8b335b80-8143-4673-8f11-d62ca09aab28" />

3. Stock Balance Chart <br>
   - The **Stock Balance Chart** view displays stock ownership of the selected stock
   - Users can add stock to watchlist or remove stock from watchlist if they are logged in.
   <img width="200" height="534" alt="Domestic and Foreign Ownership" src="https://github.com/user-attachments/assets/9d41ebe1-2360-44c6-9e24-21be944e16d1" />
   <img width="200" height="534" alt="Detailed Ownership" src="https://github.com/user-attachments/assets/224fa74a-1878-4713-80aa-4c96add20a6b" />

5. Scriptless Change <br>
   - The **Scriptless Change** view displays list of stock with changes in the number of scriptless shares over the past months.
   - User must logged in before they can access this feature.
   <img width="200" height="534" alt="Filtered Stock list" src="https://github.com/user-attachments/assets/44667d87-920e-4b83-a534-fe8e1b2ae9e2" />
   <img width="200" height="534" alt="Detailed Stock Information" src="https://github.com/user-attachments/assets/83a52835-6b96-4d57-b8fd-74036cca9886" />

6. Shareholder Change <br>
   - The **Shareholder Change** view shows list of stock with changes in the number of ownership of specific shareholder type based on the selected user criteria.
   - User must logged in before they can access this feature.
   <img width="200" height="534" alt="Filtered Local ID Decrease" src="https://github.com/user-attachments/assets/7aae7053-beee-4225-8d8b-e7f7231a2de8" />
   <img width="200" height="534" alt="Filtered Foreign MF Increase" src="https://github.com/user-attachments/assets/b19c1c25-ffc6-4e60-aedc-1742604f54bf" />

7. Register <br>
   The **Register** view allows users to create a new account. <br>
   <img width="200" height="534" alt="Register View Image" src="https://github.com/user-attachments/assets/3f91869d-dc16-4024-8f1b-f50e50f51c9b" />
   
8. Login <br>
   The **Login** view allows users to sign in to their account. <br>
   <img width="200" height="534" alt="Login View Image" src="https://github.com/user-attachments/assets/1501f85e-8eb2-4ebb-acf7-bfc158146436" />
   
9. Profile <br>
   The **Profile** view displays the user’s name and email address, and provides a logout feature. <br>
   <img width="200" height="534" alt="Profile Image" src="https://github.com/user-attachments/assets/4ee677dc-5505-4855-a942-30338eaea1a1" />
