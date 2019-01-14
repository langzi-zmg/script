package main

import (
	"github.com/parnurzeal/gorequest"
	"strings"
	"fmt"
	"encoding/json"
	"errors"
	"os"
	"bufio"
	"io"
)

type Topic struct {
	Topics  []string `json:"topics"`
	Message string   `json:"message"`
}

const (
	//sit
	url1_sit = "http://**:4171/api/topics"
	url2_sit = "http://**:4161/topic/delete"

	//prod
	url1_prod = "http://**:4171/api/topics"
	url2_prod = "http://**:4161/topic/delete"
)

func GetTopicList() {
	var topic Topic
	request := gorequest.New()
	resp, body, errs := request.Get(url1_sit).End()
	if resp.StatusCode != 200 || len(errs) != 0 {
		newError := errors.New("topicsUrl ERROR")
		print(newError)
	}
	json.Unmarshal([]byte(body), &topic)
	for _, val := range topic.Topics {
		if strings.Contains(val, "kasha") {
			fmt.Println(val)
		}
	}

}

func DeleTopicByFile() {
	request := gorequest.New()

	fi ,err := os.Open("topic")
	if err != nil{
		fmt.Println(err.Error())
		return 
	}
	defer fi.Close()
	br := bufio.NewReader(fi)

	for   {
		a, _, c := br.ReadLine()
		if c == io.EOF {
			break
		}
		a1 := string(a)

		resp, _, errs := request.Post(url2_prod+"?topic="+a1).End()
		if resp.StatusCode != 200 || len(errs) != 0 {
			newError := errors.New("topicsUrl ERROR")
			print(newError)
		}
		fmt.Printf("topic %s is already by deleted\n",a1)
	}
}
func main() {
	DeleTopicByFile()
}
