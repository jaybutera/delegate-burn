const QD = artifacts.require('QueueDelegate')

contract('Linked list test', accounts => {
   let delegate

   it('Should add 3 stakers to list', async () => {
      delegate = await QD.new();

      delegate.join(100, { from: accounts[1] })
      delegate.join(50, { from: accounts[2] })
      delegate.join(25, { from: accounts[3] })

      assert.equal( (await delegate.get(accounts[1])).toNumber(), 100)
      assert.equal( (await delegate.get(accounts[2])).toNumber(), 50)
      assert.equal( (await delegate.get(accounts[3])).toNumber(), 25)

      assert.equal(await delegate.length(), 3)
   })

   it('Should remove 3 stakers from list', async () => {
      delegate.withdraw({from: accounts[1]})
      delegate.withdraw({from: accounts[2]})
      delegate.withdraw({from: accounts[3]})

      assert.equal(await delegate.length(), 0)
   })
})
