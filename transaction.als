module transaction

open asymmetricKey

sig Hash {
	old : one Transaction,
	pubKey : one PubKey
}
-- same imput, same hash
fact HashCannonicity {
	all disj a, b : Hash {
		a.old != b.old
		a.pubKey != b.pubKey
	}
}

sig Signature {
	signee : one Hash,
	signer : one PrivKey
}
-- same imput, same key, same hash
fact SignatureCannonicity {
	all disj a, b : Signature {
		a.signee != b.signee
		a.signer != b.signer
	}
}

abstract sig Transaction {
	newOwner : one PubKey
}

sig GenesisTransaction extends Transaction {}

sig RealTransaction extends Transaction{
	hash : one Hash,
	oldOwner : one Signature
}{
	hash.pubKey = newOwner
	oldOwner.@signee = hash

	hash.old.@newOwner = oldOwner.signer.pub -- crucial verifcation step !!
}

fact NoExtraneousObjects {
	Hash in Transaction.hash
	Signature in Transaction.oldOwner
}

run {}
