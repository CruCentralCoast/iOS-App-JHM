import scrapy

class EveryStudentSpider(scrapy.Spider):
    name = "everystudent"
    allowed_domains = ["http:\/\/www.everystudent.com"]
    start_urls = ["http://www.everystudent.com/features/isthere.html"]

    def parse(self, response):
        content = response.xpath('//div[@class="contentpadding"]').extract()
        #image = response.xpath('//div[@class="contentpadding"]/img[1]/@src').extract()
        image = response.xpath('//div[@style="margin:0 0 25px 0"]/img/@src').extract()

        print image
        for sel in response.xpath('//p'):
            p = sel.xpath('text()').extract()
            #title = sel.xpath('a/text()').extract()
            #link = sel.xpath('a/@href').extract()
            #desc = sel.xpath('text()').extract()
            #print p

