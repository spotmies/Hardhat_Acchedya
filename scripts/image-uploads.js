const { NFTStorage, Blob } = require("nft.storage");
require("dotenv").config();

const API_KEY = process.env.NFT_STORAGE_API_KEY;
const client = new NFTStorage({ token: API_KEY });
const randomString = new Blob(["Hello World"]);
const func = async () => {
  const cid = await client.storeBlob(randomString);
  console.log(cid);
};

func();
