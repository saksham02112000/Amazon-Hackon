import { ethers } from 'ethers'
import { useEffect, useState } from 'react'


import {
    marketplaceAddress
} from '../../marketplaceAddress';

import NFTMarketplace from '../../../artifacts/contracts/NFTMarketplace.sol/NFTMarketplace.json';

export default function MyNFT() {
    const [nfts, setNfts] = useState([])
    const [loadingState, setLoadingState] = useState('not-loaded')
    useEffect(() => {
        loadNFTs()
    }, [])
    async function loadNFTs() {

        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner()

        const marketplaceContract = new ethers.Contract(marketplaceAddress, NFTMarketplace.abi, signer)
        const data = await marketplaceContract.fetchMyNFTs()

        const items = await Promise.all(data.map(async i => {
            const tokenURI = await marketplaceContract.tokenURI(i.tokenId)
            const meta = await fetch(tokenURI,{
                method: 'GET'
            })
                .then(res=> res.json())
            let price = ethers.utils.formatUnits(i.price.toString(), 'ether')
            let item = {
                price,
                tokenId: i.tokenId.toNumber(),
                seller: i.seller,
                owner: i.owner,
                image: meta.image,
                tokenURI
            }
            return item
        }))
        setNfts(items)
        setLoadingState('loaded')
    }
    function listNFT(nft) {
        console.log('nft:', nft)
        // router.push(`/resell-nft?id=${nft.tokenId}&tokenURI=${nft.tokenURI}`)
    }
    if (loadingState === 'loaded' && !nfts.length) return (<h1 className="py-10 px-20 text-3xl">No NFTs owned</h1>)
    return (
        <div className="flex justify-center">
            <div className="p-4">
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4">
                    {
                        nfts.map((nft, i) => (
                            <div key={i} className="border shadow rounded-xl overflow-hidden">
                                <img src={nft.image} className="rounded" />
                                <div className="p-4 bg-black">
                                    <p className="text-2xl font-bold text-white">Price - {nft.price} Eth</p>
                                    <button className="mt-4 w-full bg-purple-500 text-white font-bold py-2 px-12 rounded" onClick={() => listNFT(nft)}>List</button>
                                </div>
                            </div>
                        ))
                    }
                </div>
            </div>
        </div>
    )
}