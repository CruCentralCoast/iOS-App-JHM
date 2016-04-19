import scrapy

from articleScrape.items import ArticleItem

class EveryStudentSpider(scrapy.Spider):
    name = "everystudent"
    allowed_domains = ["http:\/\/www.everystudent.com"]
    #start_urls = ["http://www.everystudent.com/features/isthere.html"]

    def __init__(self, url=None, *args, **kwargs):
        super(EveryStudentSpider, self).__init__(*args, **kwargs)
        self.start_urls = [url]
        

    def parse(self, response):
        item = ArticleItem()
        
        item['content'] = response.xpath('//div[@class="contentpadding"]').extract()
        #image = response.xpath('//div[@class="contentpadding"]/img[1]/@src').extract()
        item['image'] = response.xpath('//div[@style="margin:0 0 25px 0"]/img/@src').extract()
        yield item
        
        #for sel in response.xpath('//p'):
            #p = sel.xpath('text()').extract()
            #title = sel.xpath('a/text()').extract()
            #link = sel.xpath('a/@href').extract()
            #desc = sel.xpath('text()').extract()
            #print p

