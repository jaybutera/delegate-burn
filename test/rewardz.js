const QD = artifacts.require('QueueDelegate')
const BurnableERC20 = artifacts.require('BurnableERC20')
const Reward = artifacts.require('Reward')

contract('Reward test', accounts => {
   let delegate
   let token
   let reward

   beforeEach( async () => {
      token    = await BurnableERC20.new(1000, { from:accounts[0] })
      delegate = await QD.new(token.address)
      reward   = await Reward.new(delegate.address)
   })

   it('Should add 3 stakers to list', async () => {
      // Give staker tokens
      token.mint(accounts[1], 100, { from: accounts[0] })
      token.mint(accounts[2], 100, { from: accounts[0] })

      // Approve delegate staking
      token.approve(delegate.address, 100, { from: accounts[1] })
      token.approve(delegate.address, 100, { from: accounts[2] })

      // Join delegate staking
      delegate.join(100, { from: accounts[1] })
      delegate.join(50,  { from: accounts[2] })

      // Finally, reward (parameters are ignored)
      const res = await reward.reward(new address[](), new uint256[]())

      console.log(res)
      //assert.equal(res.

      // Checks
      assert.equal( (await delegate.get(accounts[1])).toNumber(), 100)
      assert.equal( (await delegate.get(accounts[2])).toNumber(), 50)
   })

   it('Should remove 3 stakers from list', async () => {
      delegate.withdraw({from: accounts[1]})
      delegate.withdraw({from: accounts[2]})
      delegate.withdraw({from: accounts[3]})

      assert.equal(await delegate.length(), 0)
   })
})
