import './App.css';
import NFTMarketplace from "./Components/NFTMarketplace/NFTCreate";
import NFTHome from "./Components/NFTMarketplace/NFTHome";
import MyNFT from "./Components/NFTMarketplace/MyNFT/MyNFT";

function App() {
  return (
    <div className="App">
      <NFTMarketplace />
        <NFTHome />
        <MyNFT/>
    </div>
  );
}

export default App;
