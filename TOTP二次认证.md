# golang生成二次验证码
~~~
package main

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/base32"
	"encoding/binary"
	"fmt"
	"time"
)

func main() {
	for {
		otp, err := generateTOTP("secret", 30)
		if err != nil {
			fmt.Println("err:", err)
			return
		}
		now := time.Now().Format("2006-01-02 15:04:05")
		fmt.Printf("\r%s TOTP认证动态口令: %06d", now, otp)
		time.Sleep(time.Second)
	}
}
func generateTOTP(secret string, timeStep int64) (int64, error) {
	key, err := base32.StdEncoding.DecodeString(secret)
	if err != nil {
		return 0, err
	}
	b := make([]byte, 8)
	binary.BigEndian.PutUint64(b, uint64(time.Now().Unix()/timeStep))
	hash := hmac.New(sha1.New, key)
	hash.Write(b)
	digest := hash.Sum(nil)
	offset := digest[len(digest)-1] & 0xf
	truncatedHash := digest[offset : offset+4]
	code := int64((binary.BigEndian.Uint32(truncatedHash) & 0x7fffffff) % 1000000)
	return code, nil
}

~~~
