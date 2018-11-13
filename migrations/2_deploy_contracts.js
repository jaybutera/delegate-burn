const QD = artifacts.require('QueueDelegate')
const BSB = artifacts.require('BurnableStakeBank')
const TR  = artifacts.require('TokenRegistry')
const BurnableERC20 = artifacts.require('BurnableERC20')
const Reward = artifacts.require('Reward')

const co2knCap = 100000
const minStake = 1

module.exports = async (deployer) => {
   //const tkn = await deployer.deploy(BurnableERC20, co2knCap)
   deployer.deploy(BurnableERC20, co2knCap).then( tkn => {
   //const tr  = await deployer.deploy(TR)
   deployer.deploy(TR).then( tr => {
   //const bsb = await deployer.deploy(BSB, tr.address, minStake)
   deployer.deploy(BSB, tr.address, minStake).then( bsb => {
   //const qd  = await deployer.deploy(QD, bsb.address)
   deployer.deploy(QD, bsb.address).then( qd => {
   //const reward = await deployer.deploy(Reward, qd.address)
   deployer.deploy(Reward, qd.address)

   // QD contract needs ownership of BSB
   bsb.transferOwnership(qd.address)
   // Register co2kn in token registry
   tr.setToken('test', tkn.address)
   })
   })
   })
   })

   /*
   // QD contract needs ownership of BSB
   await bsb.transferOwnership(qd.address)
   // Register co2kn in token registry
   await tr.setToken('test', tkn.address)
   */
}
